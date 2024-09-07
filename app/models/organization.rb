class Organization < ApplicationRecord
  resourcify :admin_roles, role_cname: 'AdminRole'
  validates :name, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :description, length: { maximum: 500 }

  def assigned_admins
    admins = admin_roles.where(name: :organization_admin).first&.admin_users
    admins || AdminUser.none
  end
end
