class Role < ActiveRecord::Base
  has_and_belongs_to_many :project_managers, :join_table => :project_managers_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
