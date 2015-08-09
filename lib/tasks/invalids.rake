# Simple helpers to find invalid records and print why they are invalid. May
# take a while to run depending on size of data
if defined?(Rails)
  namespace :invalids do
    Dir.foreach("#{Rails.root}/app/models") do |item|
      next if item == '.' or item == '..' or not item
      name = item.split(".")[0].pluralize

      desc "Finds invalid records for #{name} scaffold"
      task "find:#{name}" => :environment do
        Rails.application.eager_load!
        klass = Kernel.const_get(name.classify)

        invalids = []
        index = 0
        klass.find_each do |obj|
          index += 1

          if index % 1000 == 0
            ap "invalids at index #{index}"
            ap invalids
          end

          next if obj.valid?
          invalids << { id: obj.id, errors: obj.errors }
        end

        ap "Invalids at end:"
        ap invalids

        # This is used for log based alerts
        ap "LOG NOTIFIER: INVALID RECORDS EXIST" if invalids.count > 0
      end
    end
  end
end
