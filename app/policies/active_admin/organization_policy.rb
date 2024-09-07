module ActiveAdmin
  class OrganizationPolicy < AdminPolicy
    def update?
      is_super_admin? || is_organization_admin?(record)
    end

    def index?
      is_super_admin? || is_organization_admin?
    end

    def show?
      is_super_admin? ||
        is_organization_admin?(record)
    end

    def assign_organization_admin?
      is_super_admin?
    end

    class Scope < AdminPolicy::Scope
      def resolve_for_additional_roles
        if is_organization_admin?
          scope.where(id: admin_user.assigned_organization_ids)
        end
      end
    end
  end
end
