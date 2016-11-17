class Prize < ActiveRecord::Base

  has_many :prize_subcats
  has_many :favorites
  has_many :purchases
  has_many :employees, through: :favorites

	validates_presence_of :name, :message => 'Name: Cannot be blank'
	validates_numericality_of :cost, :greater_than => 0, :message => 'Cost: Must be number and greater than 0'

  scope :top_favorited, -> {
    select("prizes.id, prizes.name, count(favorites.id) AS favorites_count").
    joins(:favorites).
    group("prizes.id").
    order("favorites_count DESC").
    limit(5) }

  scope :top_purchased, -> {
    select("prizes.id, prizes.name, count(purchases.id) AS purchases_count").
    joins(:purchases).
    group("prizes.id").
    order("purchases_count DESC").
    limit(5) }

	def self.search(id, name, available)
    if id || name 
      where('id LIKE ?
        AND name LIKE ?', "%#{id}%", "%#{name}%")
      .where(available: available)
    else
      Prize.all
    end
  end

  def self.search_store(name, category)
    if name || category
      where('name LIKE ?', "%#{name}%")
      .where(category: category, available: true)
    else
      where(available: true)
    end
  end

  def self.subsearch(name, size, color, brand)
    if name || size || color || brand
      where('name LIKE ?
        AND size LIKE ?
        AND color LIKE ?
        AND brand LIKE ?', "%#{name}%", "%#{size}%", "%#{color}%", "%#{brand}%")
      .where(available: true)
    else
      Prize.select("prizes.*, prize_subcats.*").where(available: true).joins(:prize_subcats)
    end
  end

  def get_total_stock
    PrizeSubcat.where(prize_id: self.id).sum(:stock)
  end

  def get_first_image
    if !PrizeSubcat.find_by(prize_id: self.id).nil? && !PrizeSubcat.where(prize_id: self.id).where.not(image: '').blank?
      image = PrizeSubcat.where(prize_id: self.id).where.not(image: '').first.image
      if image.blank?
        return self.image
      else
        return image
      end
    else
      return self.image
    end
  end
end
