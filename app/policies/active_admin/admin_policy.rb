module ActiveAdmin
  class AdminPolicy
    attr_reader :admin_user, :record

    include AdminPolicyMethods

    def initialize(admin_user, record)
      @admin_user = admin_user
      @record = record
    end

    def index?
      is_super_admin?
    end

    def show?
      is_super_admin?
    end

    def create?
      is_super_admin?
    end

    def new?
      create?
    end

    def update?
      is_super_admin?
    end

    def edit?
      update?
    end

    def destroy?
      is_super_admin?
    end

    class Scope
      attr_reader :admin_user, :scope

      include AdminPolicyMethods

      def initialize(admin_user, scope)
        @admin_user = admin_user
        @scope = scope
      end

      def resolve
        if is_super_admin?
          scope.all
        else
          resolve_for_additional_roles || scope.none
        end
      end

      # Can be redefined at descendant classes
      def resolve_for_additional_roles
        scope.none
      end
    end
  end
end
