module ActiveAdmin
  class PagePolicy < AdminPolicy
    def show?
      return true if is_super_admin?

      case record.name
      when 'Dashboard'
        true
      else
        false
      end
    end
  end
end
