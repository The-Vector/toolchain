# ----------------------------
# Program Options
# ----------------------------

NAME         ?= DEMO
ICON         ?= icon.png
DESCRIPTION  ?= "CE C SDK Demo"
COMPRESSED   ?= NO
ARCHIVED     ?= NO

# ----------------------------
# Debug Options
# ----------------------------

OUTPUT_MAP   ?= NO

include $(CEDEV)/include/.makefile

tilemap: src/tilemap/tilemap.csv
	cd src && cd tilemap && convbin --iformat csv -i tilemap.csv -o tilemap.c --oformat c --name tilemap_map
