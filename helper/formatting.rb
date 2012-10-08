module Ramaze
  module Helper
    module Formatting
      def two_dec_old(n)
        "%#.2f" % n
      end
      def two_dec(n)
        n = "%#.2f" % n
        s = n.to_s
        s.reverse!
        s.gsub!(/(\d\d\d)(?=\d)(?!\d*\.)/, '\1,')
        s.reverse!
      end
      def pctfmt(n)
        "%.0f %" % n
      end
      def timefmt(time)
        return "" if time.nil? or time.to_i == 0
        time.strftime('%b-%d-%Y')
      end
    end
  end
end
