
function love.load()

	n=0
	zoom=1
	sizefactor=1
	height = 200
	width = 200
	xcenter=-0.2*width
	ycenter=0
	toCompute=NewGrid(width,height)
	toDraw={x=1,y=1,z=0,n=0}

end

function love.draw()
	local x,y,mx,my,col
	mx=love.mouse.getX()
	my=love.mouse.getY()

	for i,v in ipairs(toDraw) do
		x=v.x/width *800
		y=v.y/height *600
		col=ColorIndex(v.n ,n ,v.z,2,2)*255

		col=col%255
		love.graphics.setColor(col,col,col)
		love.graphics.rectangle("fill",x,y,800/width, 600/height)
	end
	love.graphics.print("("..mx.."x "..my.."y "..') '..1/zoom..'x' , 1,1,0,1,1)
	love.graphics.print("("..width.." by "..height..') ', 1,15,0,1,1)

end


function love.update(dt)
	local x0,y0
	local a,b =0,0
	local q,z,xtemp=0,0,0
	local toRemove ={}
	local sqrt = math.sqrt
	local insert =table.insert
	local remove =table.remove


	for i,v in ipairs(toCompute) do
		a=	v.a
		b= 	v.b

		if v.z <=2 then
			x0=(((v.x - width/2) +  xcenter )/width ) * 3
			y0=(((v.y - height/2) +  ycenter )/height )*2.4
			x0=x0*(zoom)
			y0=y0*(zoom)

			xtemp = (a*a - b*b) + x0
			b = 2*(a*b) + y0
			a = xtemp
			v.a=a
			v.b=b
			z=sqrt(a*a + b*b)
			if z > 2 then
				v.z=z
				v.n=n
				insert(toDraw,v)
				insert(toRemove,i)
				--toCompute[i]=nil
			end
			q = (x0-0.25)*(x0-0.25) + y0*y0;
			if (q*(q+(x0-0.25))< 0.25*y0*y0) then
				insert(toRemove,i)
			end

		end
	end
	for i,_ in ipairs(toRemove) do
		if (i ==nil) then
		remove(toCompute,i)
		end
	end

	n=n+1

end



function love.quit()
	print("The End")
	return false
end

function love.keypressed(key)

	local x,y

	if key=="escape" then
		love.event.push('quit')
	end
	if key=="return" then

	end


	if key=="kp+" then
		sizefactor=3/2
	elseif key=="kp-" then
		sizefactor=2/3
	end


	if key=="kp+" or key=="kp-" then
		n=0
		width=math.floor(width*sizefactor)
		height=math.floor(height*sizefactor)
		print(width,height)
		x=love.mouse.getX()
		y=love.mouse.getY()
		xcenter=xcenter*sizefactor+(width *(x/800-1/2))
		ycenter=ycenter*sizefactor+(height*(y/600-1/2))

		toCompute=NewGrid(width,height)
		toDraw={x=1,y=1,z=0,n=0}
	end

end

function love.mousepressed(x,y,button)

	local zoomFactor=1

	n=0

	if button=="wu" then zoomFactor=0.5
	elseif button=="wd"then zoomFactor=2 end

	zoom=zoom*zoomFactor

	if button=="wu" or button=="wd" then
		xcenter=(xcenter+(width *(x/800-1/2)))/zoomFactor
		ycenter=(ycenter+(height*(y/600-1/2)))/zoomFactor
		toCompute=NewGrid(width,height)
		toDraw={x=1,y=1,z=0,n=0}
	else
		xcenter=xcenter+(width *(x/800-1/2))
		ycenter=ycenter+(height*(y/600-1/2))
	end


	if button=="l" then 
		local t 
		local temp={}
		for i,v in ipairs(toCompute) do
			temp[i]={x=v.x,y=v.y,a=v.a,b=v.b,z=v.z,n=v.n}
		end
		toCompute=NewGrid(width,height)
		toDraw={x=1,y=1,z=0,n=0}
		for i,v in ipairs(toCompute) do
			t=temp[(v.x-1 + xcenter )*height + v.y + ycenter]
			if not (t == nil) then 
				v.a= t.a
				v.b= t.b
				v.z= t.z
				v.n= t.n
			end
		end
	end
	
	print(x,y,1/zoom)
end



-----------------------------------------------
function NewGrid(w,h)
  local Cells = {}

  for i=1,w do
	for j=1,h do
		Cells[(i-1)*h + j] = {x=i,y=j,a=0,b=0,z=0,n=0}
	end
  end

  return Cells
end


function ColorIndex(n,N,z,M,p)
	local col = math.log(n - math.log( math.log(math.max(z,M))/math.log(M) )/math.log(p))/math.log(N)
	--local col = math.exp(- math.abs(z))

	return col
end






