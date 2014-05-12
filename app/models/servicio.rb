class Servicio < ActiveRecord::Base
  
  self.table_name = "servicios"

  has_many :empresa_servicio, :foreign_key => "id_servicio", :dependent => :destroy # elimina en cascada 
  accepts_nested_attributes_for :empresa_servicio, :allow_destroy => true 
  attr_accessible :habilitado, :nombre, :empresa_servicio_attributes

  validates :nombre ,  :presence => {:message => "No puede estar en blanco"}, :on => :create

end
