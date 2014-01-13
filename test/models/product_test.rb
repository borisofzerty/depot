require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributer must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product is not valid if title is already taken" do
    product = Product.new(title:       products(:cs).title,
                          description: "d",
                          image_url:   "x.png",
                          price:       10)

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  test "product price must be positive" do
    product = products(:cs)

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                  product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                  product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  test "description longer than 1000 chars will not be accepted" do
    product = products(:cs)
    product.description = "#" * 1001
    assert product.invalid?
  end

  test "title longer than 100 chars will not be accepted" do
    product = products(:cs)
    product.title = "#" * 101
    assert product.invalid?
  end

  test "image url" do
    product = products(:cs)

    %W{ a.jpg b.gif c.PNG d.png }.each do |name|
      product.image_url = name
      assert product.valid?, "#{name} should be valid"
    end

    %W{ a.jpeg b.guf c.PONG dpng}.each do |name|
      product.image_url = name
      assert product.invalid?, "#{name} shouldn't be valid"
    end

  end
end
