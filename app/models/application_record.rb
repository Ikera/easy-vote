class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Keep .first/.last deterministic with UUID primary keys.
  self.implicit_order_column = :created_at
end
