module Ramaze
  module Helper
    module Views
      def timefmt(time)
        return "" if time.nil?
        time.strftime('%F %T')
      end
    end
  end
end
