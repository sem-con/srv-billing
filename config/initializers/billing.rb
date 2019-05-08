GPGME::Key.import(File.open(ENV["KEY_FILE"].to_s)) rescue nil
if !File.exist?(ENV["HOME"].to_s + '/.gnupg/gpg-agent.conf')
	File.write(ENV["HOME"].to_s + '/.gnupg/gpg-agent.conf', 'allow-loopback-pinentry')
end
if !File.exist?(ENV["HOME"].to_s + '/.gnupg/gpg.conf')
	File.write(ENV["HOME"].to_s + '/.gnupg/gpg.conf', 'pinentry-mode loopback')
end
if !File.exist?(ENV["HOME"].to_s + '/.gnupg/dirmngr.conf')
	File.write(ENV["HOME"].to_s + '/.gnupg/dirmngr.conf', 'disable-ipv6')
end

puts "gpg configuration done"