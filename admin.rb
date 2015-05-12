require 'pry'
require '~/Desktop/ruby/board_db/lib/database_methods'

class Admin < User
  
  def delete_ad ad
    ad.delete
  end

end

#в таблицу могут записоваться только валидные данные
#raise