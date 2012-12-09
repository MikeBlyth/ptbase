require 'interpolate'

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

  WT_MALE = InterpolationArray.new([ [0,3.0], [0.25,6.0], [0.5,7.6], [0.75, 9.2], [1.0, 10.2], [1.5,11.5], [3, 14.7],  [5,18.5], [7.5,24], [9,28],
                                     [12,40], [15,57], [18,69], [100,69] ])
  WT_FEMALE = InterpolationArray.new(	[  [0,3.0], [0.25,5.4], [0.5,7.2], [0.75, 8.6], [1.0, 9.6], [1.5,10.8], [2.0, 11.9], [3, 14],  [4,16], [6,19.5],
                                          [7,22], [8,24.7], [12,41.5], [15,53.5], [16,56], [18,57], [100,57] ])
  HT_MALE = InterpolationArray.new([ [0,50], [0.25,61], [0.5,68], [0.75, 72.5], [1.0, 76.2], [1.5,82.5], [3, 97.5],
                                     [4,103], [6,116], [10,137.5], [12,149.5], [15,168], [18,176.5], [100,176.5] ])
  HT_FEMALE = InterpolationArray.new(	[ [0,50], [0.25,59.5], [0.5,66], [0.75, 70.5], [1.0, 74.2], [1.5,81], [3, 95.5],
                                         [6,114.5], [10,138], [12,151.5], [13.5,159], [15,162], [18,163.5 ], [100,163.5] ])
  WT_HT_MALE = InterpolationArray.new([ [49,3.1], [76,10], [90,13.25], [110,18.5], [125,24.5], [135,29.5], [145, 37]  ])
  WT_HT_FEMALE = InterpolationArray.new(	[ [49,3.5], [76,10], [90,13], [106,17], [46.5,21], [126.5,25], [137,31.5] ])

  def wt_50(age,sex)
# Return median weight for a given age and sex.
    return nil if age.nil?
    if sex[0,1].downcase == 'm'
      WT_MALE.interpolate(age)
    else
      WT_FEMALE.interpolate(age)
    end
  end

  def ht_50(age,sex)
# Return median height for a given age and sex.
    return nil if age.nil?
    if sex[0,1].downcase == 'm'
      HT_MALE.interpolate(age)
    else
      HT_FEMALE.interpolate(age)
    end
  end

  def wt_ht_50(height,sex)
# Return median weight for a given height and sex, or nil if out of range
    return nil if height.nil?
    if sex[0,1].downcase == 'm'
      WT_HT_MALE.interpolate(height)
    else
      WT_HT_FEMALE.interpolate(height)
    end
  end


end