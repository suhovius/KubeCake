# frozen_string_literal: true
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Prompts by Reviews count' do
          pie_chart(
            ::AI::CodeReview::Prompt.all.each_with_object({}) do |prompt, data|
              data[emojify_unicode(prompt.title)] = prompt.reviews_count
            end
          )
        end
      end

      column do
        panel 'Prompts by Repositories count' do
          data = ::AI::CodeReview::Prompt.joins(:repositories).group('ai_code_review_prompts.title').count
          data.transform_keys! { |title| emojify_unicode(title) }
          bar_chart(
            data.sort_by { |title, count| -1 * count }
          )
        end
      end
    end

    columns do
      column do
        panel 'Accounts by Repositories count' do
          column_chart(
            ::Github::Account.joins(:repositories).group('github_accounts.login').count
          )
        end
      end
    end

    columns do
      column do
        days_offset = 30
        panel "Installations dynamics in #{days_offset} days" do
          # In future versions it might support multiple apps
          # so app_slug is being extracted here
          app_slugs = ::Github::Installation.distinct(:app_slug).pluck(:app_slug)
          installations = ::Github::Installation.where("created_at >= ?", Time.zone.now - days_offset.days)

          line_chart(
            app_slugs.map do |app_slug|
              {
                name: app_slug,
                data: installations.where(app_slug:).group_by_day(:created_at).count
              }
            end
          )
        end
      end
    end
  end
end
