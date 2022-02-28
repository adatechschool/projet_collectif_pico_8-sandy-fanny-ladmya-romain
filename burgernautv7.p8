pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	--menu
	scene="menu"
	x=63
	y=63
 p={x=60,y=60,speed=4} --creation p:player
 -- fin menu
 bullets={} --tirs 
 enemies={}
 ebullets={} --creation projectile
 rand=flr(rnd(4))
 explosions={}
 create_stars()
 score=0
 state=0 --etat de scene de jeu: combat/menu/ game over
	gun_timer=5
	gun_cooldown=45
end

--menu erreurs si deplacemt
function update_menu()
  if btnp(❎) then scene="game"
  end
end

function draw_menu()
	cls()
	print("welcome, padawan!",30,33)
	print("press ❎ to start",30,63)
end
--fin menu
function _update60()
 if scene=="menu" then 
 update_menu()
 elseif scene=="game" then 
 if(state==0) update_game()	
 if(state==1) update_gameover()	
 end
end


function _draw()
 if scene=="menu" then
 draw_menu()
 elseif scene=="game" then
  if(state==0) draw_game()
	 if(state==1) draw_gameover()
 end
end

function update_game()
	update_player()
	update_bullets()
	update_ebullets()
	update_stars()
	if #enemies==0 then --hashtag appelle les valeurs du tableau
		spawn_enemies(2+ceil(rnd(3)))--nb aleatoire de foes  -- interaction spr
	end
	update_enemies()
	countdown()
	--if rand then eshoot() end

	update_explosions()
	--state=1
end

function draw_game()
 --affichage couleur fond d'ecran
 cls(1)
 --stars
 for s in all(stars) do
 	pset(s.x,s.y,s.col)
 end
 --vaisseau
 --spr(33,p.x,p.y,2,2) --p pour player
 spr(32,p.x,p.y)
 -- enemies
 for e in all(enemies) do
  spr(6,e.x,e.y)
 end
 --explosions
draw_explosions()
 --bullets
 for b in all(bullets) do --boucle balle
 	spr(26,b.x,b.y)
 end  
 --ebullets
  for eb in all(ebullets) do --boucle balle
 	spr(22,eb.x,eb.y)
 end  
 --score
 --print("texte",x,y,couleur)
 print("score:\n"..score,2,2,15)
 -- :\n permet d'aller a la ligne
 -- .. concatenation
 -- print("score:",2,2,15) 
 -- print(score,2,8,10)
end
-->8
--shoot
function shoot()--tableau
	new_bullet={ --creation projectile
	x=p.x,
	y=p.y,
	speed=2
	} 
	 add(bullets,new_bullet)-- ajouter elts dans tableau
	 sfx(0) -- son tir
end
   
function update_bullets() --maj position projection balle
	for b in all(bullets)  do
	b.y-=b.speed
	 if b.y<-8 then --supprime les balles en ht d'ecran pour ne pas tuer les enemies a venir
	 del(bullets,b)
	 end
	end	
end

 function eshoot()   	   
	new_ebullet={ --creation projectile
	x=new_enemy.x,
	y=new_enemy.y,
	speed=1
	} 
	 add(ebullets,new_ebullet)
	 -- ajouter elts dans tableau
sfx(1) -- son tir
end


function update_ebullets() --maj position projection balle
	for eb in all(ebullets)  do
	eb.y+=eb.speed
	 if eb.y<-8 then --supprime les balles en ht d'ecran pour ne pas tuer les enemies a venir
	 del(ebullets,eb)
	 end
	end	
end

function countdown()
	gun_timer-=1
	if gun_timer==0 then	eshoot()
	if gun_timer==0 then gun_timer=gun_cooldown
	--if gun_timer==0 then 
	--elseif gun_time>0 then gun_timer==gun_cooldown
end
	end
	end
-->8
--stars
function create_stars()
  stars={}
  for i=1,20  do --scope boucle qui tourne de 1 a 20
  local new_star={
    x=rnd(128),
    y=rnd(128),
    col=10,
    speed=4
    }
   add(stars,new_star)
  end	
end
   
function update_stars()
 for s in all(stars) do  -- s pour chaque star
 s.y+=s.speed
  if s.y>128 then
  s.y=0
  s.x=rnd(128)  	
  end		
 end
end



-->8
--enemies
function spawn_enemies(nbf)--chiffrer les foes
	gap=(128-8*nbf)/(nbf+1) --espacement foes ecran/ +1 espace /8 taille spr
	 for i=1,nbf do --i=ecart
	 new_enemy={
	 x=gap*i+8*(i-1),
	 y=-20,
	 life=4
 	}
	add (enemies,new_enemy) 	
	end
end
   
function update_enemies ()
	for e in all(enemies) do
	e.y+=0.45 -- vitesse descente enemies 
	 if e.y > 128 then
		del(enemies,e) -- supprime les enemies du bas de l'ecran
	 end 
	--collision
   for b in all(bullets) do
	   if collision(e,b) then
	   create_explosion(b.x+4,b.y+2)--4 et 2 centre l'explosion
	   del(bullets,b) -- supprime les balles    
	   -- decompte vies	
	   e.life-=1
	    if e.life==0 then
		   del (enemies,e) --supprime l'ennemi une fois canne
		    score+=100 --score points
	    end
	   end
	  end
	 end
 end
 
 -- function enemiesshoot()
 --	for e in all(enemies) do eshoot()
 --end
 --end
-->8
--collision
function collision(a,b)--calculer les espaces libres pour deduire une collision
	if a.x>b.x+8
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then
		return false
		else
		return true
		--ou
		--return not (a.x>b.x+8
				  -- or a.y>b.y+8
			   -- or a.x+8<b.x
			   -- or a.y+8<b.y
	end
	end
-->8
--explosions
function create_explosion(x,y)
	sfx(2)
	add(explosions,{x=x,
					y=y,
					timer=0}) --x et y permettent de prendre differentes valeurs dans la fonction	
end
   
function update_explosions()
	for ex in all(explosions) do
	ex.timer+=1
	 if ex.timer==13 then
		del(explosions,ex)
	 end 
 end
end
   
function draw_explosions()--cercle d'explosion
circ(x,y,rayon,color)
	for ex in all(explosions) do
	circ(ex.x,ex.y,ex.timer/2,--taille du cercle
	8+ex.timer%3)	--halo de couoleur
	end
end
-->8

-->8
-- player
function update_player()
	if (btn(➡️)) and p.x<120 then p.x+=p.speed end --player speed
	if (btn(⬅️)) and p.x>0	then p.x-=p.speed	end
 if (btn(⬆️)) and p.y>0	then p.y-=p.speed end
 if (btn(⬇️)) and p.y<120	then p.y+=p.speed end
 if (btnp(❎)) shoot() --btnp=intervalle tir

-- fais mourir player en cas de collision
-- enclenche une reinitialisation		
for e in all(enemies) do
	if collision(e,p) then state=1
end
end
end

-->8
--game over
function update_gameover()
--state=0
if (btn(🅾️)) _init()
end

function draw_gameover()
cls(1)
--rectfill(x,y,x2,y2,couleur)
rectfill(15,40,110,90,6)--display rectangle
print("score:"..score,45,25,7)
print("game over",45,60,8)
print("🅾️/c to continue",30,75,5)
end
__gfx__
00000000080000800a0000a0000990000a0000a000888800004444000aaafa00099999900000000000888000030bb030000003300bb009a90000000000000000
00000000060000600a0000a0089749800000000008a99a8004444440afafafa09999999900000000000e88000833338000099aa300bb9a9a0000000000000000
00700700060a60600a0000a0097474900a0000a08a0000a8444ff444aaaafaf0888888880000000080002800838338380b9994a333b9a9a90000000000000000
00077000044a64400a0000a097474749080000808900009844499444878787803aaaaaa3000000008e08802087e88888ba444ab30b9a9a900000000000000000
00077000445a664409000090097474900000000089000098f444444f87878780444aa44400000000882e08008e888888baaaab330ba9a9b00000000000000000
00700700455aa55409000090089749800a0000a08a0000a89f4444f98787878044444444000000000880e822888888883bbbb3300bba9bbb0000000000000000
0000000005855850080000800a0990a00800008008a99a8009ffff90878787809999999900000000000202888888888803333300b3bbb30b0000000000000000
0000000000a55a00000000000a0000a0080000800088880000999900878787800999999000000000000002800888888000333000bb0003000000000000000000
0000000000000000000000000000000000000000000000000888000002240000004444000000000000bb00bb000bb0bb0bb00bb0000000000000000000000000
0000000000000000000000000000000000000000000000008788e00092274000049949400000000000bbb0bb0000b3bbb0bbbb0b000000000000000000000000
0000000000000000000000000000000000000000000000008888e200f922740094a4a9940000000000003b300000bb30000bb000000000000000000000000000
000000000000000000000000000000000000000000000000888e2800ff922740a000a94400000000000030b300099bbb0eeeeee0000000000000000000000000
0000000000000000000000000000000000000000000000000ee282000ff9227400000494000000000088b0bb009f990beffeeffe000000000000000000000000
0000000000000000000000000000000000000000000000000028270000ff9222000009af000000000888800009a9900077777777000000000000000000000000
00000000000000000000000000000000000000000000000000000070000ff92200000aa9000000000e8880000999000007777770000000000000000000000000
000000000000000000000000000000000000000000000000000000070000ff9000000a00000000007ee800009900000000077000000000000000000000000000
00888000000088888800000000099999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000e8800000088888800000000099999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80002800000000ee8888000099999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8e088020000000ee8888000098899999999998890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
882e0800880000000088000088888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0880e82288000000008800008bb8888888888bb80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002028888ee008888002200b87aaaaaaaaaa78b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000002e088ee008888002200870a44aaaa44a0780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888822ee0088000044444444444444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888822ee0088000044444400004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000888800ee88222244444077770444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000888800ee88222244444078870444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000220022888899990788887099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000220022888899999078870999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022ee0000099907709999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000022ee0000099990099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a000a000a00a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000a000a000a00a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200003b0703a0603805034050310502c050220501d040200301d0201de102800025e1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000003050050500805004050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
