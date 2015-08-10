module EpPostmaster
  class Postmaster < ::ActionMailer::Base

    def bounced_email(options = {})
      @to = options.fetch(:original_sender) { options.fetch(:reply_to) }
      @recipient = options.fetch(:original_recipient)
      @subject = options[:original_subject]
      @error =  options[:error]
      notification_subject = "Failed Delivery to #{@recipient}"
      notification_subject = "#{notification_subject}: #{@subject}" if @subject

      from = options.fetch(:from) do
        from = EpPostmaster.configuration.mailer_sender
        from = from.call(options.fetch(:original_message)) if from.respond_to?(:call)
        from
      end

      mail to: @to, from: from, subject: notification_subject
    end

  end
end
