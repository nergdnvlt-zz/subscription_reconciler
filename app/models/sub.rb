class Sub < ApplicationRecord
  validates_uniqueness_of :fs_id, allow_blank: true, case_sensitive: false
  validates_uniqueness_of :xsolla_id, allow_blank: true, case_sensitive: false
end
