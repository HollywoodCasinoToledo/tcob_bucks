class NotificationsController < ApplicationController
	include EmployeesHelper
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def index
		@notifications = Notification.where(to_id: @current_user.IDnum)
	end

	def mark_as_read
		Notification.where(id: params[:notification_ids]).update_all(read: true)
		flash[:title] = 'Success'
		flash[:notice] = 'Notifications marked as read.'
		redirect_to action: :index
	end

	def mark_all_as_read
		Notification.all.update_all(read: true)
		flash[:title] = 'Error'
		flash[:notice] = 'All notifications marked as read.'
		redirect_to action: :index
	end
end
