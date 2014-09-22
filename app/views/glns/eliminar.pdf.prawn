
if params[:gln] != ''
  @glns = @glns.where("gln.gln like :search", search: "%#{params[:gln]}%" )
end

if params[:tipo_gln] != ''
  @glns = @glns.where("tipo_gln.nombre like :search", search: "%#{params[:tipo_gln]}%" )
end

if params[:codigo_localizacion] != ''
  @glns = @glns.where("gln.codigo_localizacion like :search", search: "%#{params[:codigo_localizacion]}%" )
end
if params[:descripcion] != ''
  @glns = @glns.where("gln.descripcion like :search", search: "%#{params[:descripcion]}%" )
end

if params[:fecha_asignacion] != ''
  @glns = @glns.where("gln.fecha_asignacion like :search", search: "%#{params[:fecha_asignacion]}%" )
end
if params[:estado] != ''
  @glns = @glns.where("estados.nombre like :search", search: "%#{params[:estado]}%")
end

if params[:municipio] != ''
  @glns = @glns.where("municipio.nombre like :search", search: "%#{params[:municipio]}%" )
end

if params[:ciudad] != ''
  @glns = @glns.where("ciudad.nombre like :search", search: "%#{params[:ciudad]}%" )
end

glns = Array.new
glns = [["GLN", "Tipo GLN", "Código localización", "Descripción", "Fecha Asignación","Estado", "Municipio", "Ciudad"]]

@glns.each do |empresa_gln|

  glns << [empresa_gln.try(:gln).try(:gln), empresa_gln.try(:gln).try(:tipo_gln).try(:nombre), empresa_gln.try(:gln).try(:codigo_localizacion), empresa_gln.try(:gln).try(:descripcion),  empresa_gln.try(:gln).try(:fecha_asignacion).strftime("%Y-%m-%d"), empresa_gln.try(:gln).try(:estado).try(:nombre),empresa_gln.try(:gln).try(:municipio).try(:nombre), empresa_gln.try(:gln).try(:ciudad).try(:nombre)] 

 end

draw_text "Empresa: #{@empresa.nombre_empresa}", :size => 8, :at => [0,735]
draw_text "Listado de GLN", :size => 8, :at => [0,720]
draw_text "Fecha:#{Time.now.strftime("%Y-%m-%d")}", :size => 8, :at => [0,705]
move_down 40
#number_pages "(<page>/<total>)", :size => 9, :at => [700, 550]
table(glns,  :row_colors => ["FFFFFF", "DDDDDD"], :cell_style => { size: 8 }, :column_widths => [50,80,80,70,45,40])
