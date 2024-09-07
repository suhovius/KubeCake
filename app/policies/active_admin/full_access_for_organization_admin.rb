module ActiveAdmin
  module FullAccessForOrganizationAdmin
    %i[create index].each do |action|
      define_method("#{action}?") do
        is_super_admin? || is_organization_admin?
      end
    end

    %i[show update destroy].each do |action|
      define_method("#{action}?") do
        is_super_admin? || (
          is_organization_admin? && admin_user.assigned_organization_ids.include?(record.organization_id)
        )
      end
    end

    class Scope < AdminPolicy::Scope
      def resolve_for_additional_roles
        if is_organization_admin?
          scope.where(organization_id: admin_user.assigned_organization_ids)
        end
      end
    end
  end
end
