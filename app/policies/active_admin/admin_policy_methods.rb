module ActiveAdmin
  module AdminPolicyMethods
    def is_super_admin?
      admin_user.has_cached_role?(:super_admin)
    end

    def is_organization_admin?(organization = :any)
      admin_user.has_cached_role?(:organization_admin, organization)
    end
  end
end
