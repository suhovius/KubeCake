class AdminRole < ApplicationRecord
  ALLOWED_ROLES = %w[super_admin organization_admin].freeze

  has_and_belongs_to_many :admin_users, join_table: :admin_users_admin_roles
  
  belongs_to :resource,
             polymorphic: true,
             optional: true
  
  belongs_to :organization, foreign_key: :resource_id, class_name: 'Organization', optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name,
            inclusion: { in: ALLOWED_ROLES },
            allow_nil: false

  validate do
    organization_presence_check if organization_admin?
  end

  scopify

  private

  def organization_admin?
    name == 'organization_admin'
  end

  def organization_presence_check
    return if resource.is_a?(Organization) && resource_id
    errors[:organization] << 'can\'t be blank'
  end
end
