class Suggest < ApplicationRecord
    def options
        self[:option]&.split(',')
    end
end
