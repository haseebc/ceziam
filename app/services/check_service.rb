require 'rubygems'
require 'net/ssh'
require 'net/scp'
require 'crack'
require 'json'
require 'open-uri'

class CheckService

  def initialize(check_id)
    @check = Check.find(check_id)
    @target = @check.hostname
    @jumphost = 'websec.app'
    @username = 'checksuser'
    @password = ENV['PASS_SECRET']
  end

  def run
    begin_checks = Time.now

    ports_check_response = ports_check
    @check.fullresponse = ports_check_response if ports_check_response

    subdomain_response = subdomains_check
    @check.attacksurface = subdomain_response if subdomain_response

    vercheck_response = version_check
    @check.version_info = vercheck_response if vercheck_response

    end_checks = Time.now
    duration_checks = (end_checks - begin_checks)

    @check.duration = duration_checks.round(2).to_s
    @check.complete!
    @check.save!
    @check.set_vulnerabilities
    @check.set_check
    @check
  end

  def ports_check
    ports_to_check = '7,9,13,19,20,21,23,25,37,53,67,69,80,113,115,135,137,138,139,161,389,445,548,1433,3389'
    cmd = "nmap -sV -oX /var/www/html/output2.xml -p #{ports_to_check} #{@target}"

    Net::SSH.start(@jumphost, @username, password: @password) do |ssh|
      res = ssh.exec!(cmd)
      ssh.close
      puts res
    end

    # Convert the XML file into JSON file
    unparsed_doc = open('http://websec.app:8080/output2.xml')
    Crack::XML.parse(unparsed_doc).to_json
  rescue StandardError
    raise "Unable to connect to #{@jumphost} using #{@username}"
  end

  def subdomains_check
    # attacksurface_check
    # this is using a hacked version of Enumall.sh, which is based on the Recon-Ng.
    # Enumall.sh uses Google scraping, Bing scraping, Baidu scraping, Netcraft, and brute forcing using a wordlist.
    # You can see a demo of the script here:
    cmd_attack_surface = "/home/haseeb/tools/recon-ng/domain/enumall.py #{@target}"
    cmd_send_to_apache = 'mv * /var/www/html/'

    Net::SSH.start(@jumphost, @username, password: @password) do |ssh|
      ssh.exec!(cmd_attack_surface)
      res = ssh.exec!(cmd_send_to_apache)
      ssh.close
      puts res
    end

    # Get the newly created json file and have it neat to present in HTML
    url = "http://websec.app:8080/#{@target}.json"
    serialized_subdomains = open(url).read
    JSON.parse(serialized_subdomains)
  rescue StandardError
    raise "Unable to connect to #{@jumphost} using #{@username}"
  end

  def version_check
    cmd = "cd /var/www/html && nmap -sV --script=vulners -oX /var/www/html/vercheck_output1.xml #{@target}"

    Net::SSH.start(@jumphost, @username, password: @password) do |ssh|
      res = ssh.exec!(cmd)
      ssh.close
      puts res
    end

    unparsed_doc = URI.open('http://websec.app:8080/vercheck_output1.xml')
    Crack::XML.parse(unparsed_doc).to_json
  rescue StandardError
    raise "Unable to connect to #{@jumphost} using #{@username}"
  end

end
