module HandshakeService
  module LibratoHelper
    def self.increment(metric_name, amount = 1, options = {})
      Bugsnag.notify("LibratoHelper.increment called with no metric_name.") and return unless metric_name.present?

      sanitized_name = sanitize_metric_name(metric_name)
      Librato.increment sanitized_name, { by: amount }.merge(options)
    rescue Exception => e
      handle_exception(e)
    end

    def self.measure(metric_name, amount = 1, options = {})
      Bugsnag.notify("LibratoHelper.measure called with no metric_name.") and return unless metric_name.present?

      sanitized_name = sanitize_metric_name(metric_name)
      Librato.measure sanitized_name, amount, options
    rescue Exception => e
      handle_exception(e)
    end

    def self.timing(metric_name, time = nil, options = {}, &block)
      Bugsnag.notify("LibratoHelper.timing called with no metric_name.") and return unless metric_name.present?

      sanitized_name = sanitize_metric_name(metric_name)
      Librato.timing sanitized_name, time, options, &block
    rescue Exception => e
      handle_exception(e)
    end

    def self.group(metric_name, &block)
      Librato.group(sanitize_metric_name(metric_name), &block)
    rescue Exception => e
      handle_exception(e)
    end

  private

    # http://dev.librato.com/v1/metric-attributes
    def self.sanitize_metric_name(metric_name)
      metric_name.gsub(/[^A-Za-z0-9.:-_]/) { '-' }.first(255)
    end

    def raise_librato_exceptions?
      !ENV["DISABLE_RAISE_LIBRATO_EXCEPTIONS"].to_b
    end

    def handle_exception(exeception)
      if raise_librato_exceptions?
        raise exception
      else
        Rails.logger.warn exception
      end
    end
  end
end
