def consolidate_cart(cart:[])
  cart.each_with_object({}) do |value, cart_array|
    value.each do |type, attributes|
      if cart_array[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        cart_array[type] = attributes
      end
    end
  end
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] -= coupon[:num]
    end
  end
  cart
end


def apply_clearance(cart:[])
  cart.each do |item, details|
    if details[:clearance]
      updated_price = details[:price] * 0.8
      details[:price] = updated_price.round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart)
  couponed_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)
  final_cart = apply_clearance(cart: couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end