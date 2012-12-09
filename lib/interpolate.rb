class InterpolationArray < Array
# Initialize with an array of [x,y] points. Must be in ascending order of x.
# call interpolate(x) to find the interpolated y value for x.
# If x is out of range, nil is returned
# Example
# a = InterpolationArray.new([[0, 0], [1, 2], [2, 4], [3, 9]])
# y = a.interpolate(2.3)
  def interpolate (x)
    return nil if (x < self[0][0]) || (x > self[-1][0])   # x is out of range of array
    i = 0
    i = i + 1 while (i < self.length-1) && (self[i+1][0] < x )
    return (self[i][1] + ((x-self[i][0])/(self[i+1][0]-self[i][0]))* (self[i+1][1]-self[i][1]))
  end
end

