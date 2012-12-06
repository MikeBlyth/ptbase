module Anthropometrics
  # Given params including :weight (kg) and optionally :height (cm), return estimated BSA (m2)
  def body_surface_area(params={})
      weight = params[:weight]
      height = params[:height]
      return nil if weight.nil? || weight < 0.5    # presumably too small for us to estimate??
      # ToDo - check limits for this estimation equation.
      return Math.sqrt(height * weight/3600) if (height and height > 0)  # the easy way, with height and weight

      # otherwise, estimate from weight alone, see 
      #  Sharkey I et al., Body surface area estimation in children using weight alone: ... 
      #  Br J Cancer. 2001 Jul 6;85(1):23-8. http://dx.doi.org/10.1054/bjoc.2001.1859
      weight_g = weight * 1000   # convert to grams
      4.688 * weight_g**(0.8168 - (0.0154 * Math.log10(weight_g))) / 10000
  end
    
end