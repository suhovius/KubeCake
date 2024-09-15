module ActiveAdmin
  module Github
    class RepositoryAICodeReviewPromptPolicy < AdminPolicy
      [:reorder].each do |action|
        define_method("#{action}?") do
          is_super_admin?
        end
      end
    end
  end
end