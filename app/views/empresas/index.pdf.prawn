@empresas = @empresas.where("prefijo like :search", search: "%#{params[:prefijo]}%") if (params[:prefijo] != '')
@empresas = @empresas.where("nombre_empresa like :search", search: "%#{params[:nombre_empresa]}%") if (params[:nombre_empresa] != '')
@empresas = @empresas.where("CONVERT(varchar(255),  empresa.fecha_activacion ,126) like :search", search: "%#{params[:fecha_activacion]}%") if (params[:fecha_activacion] != '')
@empresas = @empresas.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%") if (params[:ciudad] != '')
@empresas = @empresas.where("empresa.rif like :search", search: "%#{params[:rif]}%")  if (params[:rif] != '')

if params[:sub_estatus].present?
  
  if params[:sub_estatus].upcase == "D" or params[:sub_estatus].upcase == "DE" or params[:sub_estatus].upcase == "DEU" or params[:sub_estatus].upcase == "DEUD" or params[:sub_estatus].upcase == "DEUDO" or params[:sub_estatus].upcase == "DEUDOR"
    
    @empresas = @empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) != 2")

    
  elsif params[:sub_estatus].upcase == "S" or params[:sub_estatus].upcase == "SO" or params[:sub_estatus].upcase == "SOL" or params[:sub_estatus].upcase == "SOLV" or params[:sub_estatus].upcase == "SOLVE" or params[:sub_estatus].upcase == "SOLVE" or params[:sub_estatus].upcase == "SOLVEN" or params[:sub_estatus].upcase == "SOLVENT" or params[:sub_estatus].upcase == "SOLVENTE" 

    @empresas = @empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) = 2")

  else
    
    @empresas = @empresas.where("isnull([BDGS1DTS.MDF].dbo.fnc_CltSlv.codigo, 2) like '#{params[:sub_estatus]}'")
  end 

end


empresas = Array.new

empresas = [['Prefijo', 'Nombre Empresa', 'Fecha Activación', 'RIF', 'Estatus', 'Sub Estatus',   'Categoria', 'Division', 'Grupo', 'Clase']]

@empresas.each do |empresa|
	
	fecha = empresa.fecha_inscripcion
	fecha =  empresa.fecha_activacion.strftime("%Y-%m-%d") if (empresa.fecha_activacion)
				if empresa.solv == 2
					solvencia =  "SOLVENTE"
				else
					solvencia = "DEUDOR"
				end
	empresas << sheet.add_row [empresa.prefijo,empresa.try(:nombre_empresa),fecha,empresa.try(:rif),empresa.try(:estatus_), solvencia, empresa.try(:division), empresa.try(:categoria), empresa.try(:grupo), empresa.try(:clase)]
	
 end

draw_text "Empresas Activas", :size => 10, :at => [0,560]
draw_text "Fecha: #{Time.now.strftime("%Y-%m-%d")}", :size => 10, :at => [0,545]
move_down 40
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(empresas,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,100,50,70,65,40])











 



 