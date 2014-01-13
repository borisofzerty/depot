class Product < ActiveRecord::Base
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  def self.lastest
    Product.order(:updated_at).last
  end


  validates :title, :description, :image_url, presence: true
  validates :description, length: 1..1000
  validates :title, length: 1..100
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:     %r{\.(gif|jpg|png)\Z}i,
    message:  "must be a URL for gif, jpg or png image."
  }
  validates :price, numericality: {greater_than_or_equal_to: 0.01}


  private
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end
