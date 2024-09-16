namespace :ai do
  namespace :code_review do
  	namespace :prompts do
	  	desc 'Create AI Code Revew Prompts'

	  	task create: :environment do
		  	Dir["#{::Rails.root}/config/prompts/**/*.yml"].sort.each do |file_path|
				  prompt_data = YAML.load(File.read(file_path))

				  # Skip if already exists
				  next if AI::CodeReview::Prompt.find_by(title: prompt_data['title'])

				  AI::CodeReview::Prompt.create!(prompt_data)
				end
	  	end
	  end
	end
end
