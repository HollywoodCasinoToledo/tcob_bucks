class Notification < ActiveRecord::Base
	belongs_to :to, class_name: 'Employee'
	belongs_to :from, class_name: 'Employee'

	ACHIEVEMENT = "ACHIEVEMENT"
	NEW_BUCK = "NEW_BUCK"
	BUCK_APPROVED = "BUCK_APPROVED"
	BUCK_DENIED = "BUCK_DENIED"
	PENDING_BUCK = "PENDING_BUCK"
	PENDING_ORDER = "PENDING_ORDER"
	REFUND_PRIZE = "REFUND_PRIZE"
	ORDER_COMPLETE = "ORDER_COMPLETE"

	def get_target_url
		case self.category
			when ACHIEVEMENT
				return '/employees/' + self.to_id.to_s + '/achievements'
			when NEW_BUCK, BUCK_APPROVED, BUCK_DENIED
				return '/bucks/' + self.target_id.to_s
			when PENDING_BUCK
				return '/bucks/pending/' + self.target_id.to_s
			when PENDING_ORDER
				return '/admin/orders'
			when ORDER_COMPLETE
				return '/employees/' + self.to_id.to_s
			when REFUND_PRIZE
				return '/employees/' + self.to_id.to_s
			else
				return '#'
		end
	end

	def get_message
		case self.category
			when ACHIEVEMENT
				return 'You\'ve earned an achievement!'
			when NEW_BUCK
				return 'You\'ve been awarded $' + Buck.find(self.target_id).value.to_s + ' for ' + Buck.find(self.target_id).reason_short + '!'
			when BUCK_APPROVED
				return 'Buck request has been approved'
			when BUCK_DENIED
				return 'Buck request has been denied'
			when PENDING_BUCK
				return 'Buck requiring approval'
			when PENDING_ORDER
				return 'New order for ' + Prize.find(self.target_id).name
			when ORDER_COMPLETE
				return 'Order for ' + Prize.find(self.target_id).name + ' completed!'
			when REFUND_PRIZE
				return 'You\'ve been refunded $' + Prize.find(self.target_id).cost 
			else
				return 'New notification'
		end
	end

end
