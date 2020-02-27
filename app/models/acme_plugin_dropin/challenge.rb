module AcmePluginDropin
  class Challenge
    def self.current_challenge(options = Config.load_config)
      challenge_dir = options[:challenge_dir_name]
      response = IO.read(File.join(Rails.root, challenge_dir, 'challenge'))
    end

    def self.store_challenge(challenge_text, options = Config.load_config)
      challenge_dir = File.join(Rails.root, options[:challenge_dir_name])
      Dir.mkdir(challenge_dir) unless File.directory?(challenge_dir)

      File.open(File.join(challenge_dir, 'challenge'), 'w') { |file| file.write(challenge_text) }
      puts "Challenge #{challenge_text} has been stored"
    end
  end
end
