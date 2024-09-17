namespace :ai do
  namespace :code_review do
		namespace :prompts do
			desc 'Update AI Code Revew Prompts from Templates'
	  	task update: :environment do
		  	Dir["#{::Rails.root}/config/prompts/**/*.yml"].sort.each do |file_path|
				  prompt_data = YAML.load(File.read(file_path))

				  AI::CodeReview::Prompt.find_or_initialize_by(key: prompt_data['key']).tap do |prompt|
				  	prompt.assign_attributes(prompt_data)
				  	prompt.save!
				  end
				end
	  	end
	  end
	end
end
