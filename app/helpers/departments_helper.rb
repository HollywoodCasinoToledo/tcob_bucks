module DepartmentsHelper

	def reason_count(bucks, reason)
		total = 0
		bucks.each do |e| 
			if e.reason_short == reason
				total += 1
			end
		end

		return total
	end

end
