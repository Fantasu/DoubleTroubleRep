tool
extends TileSet

func _is_tile_bound(drawn_id, neighbor_id):
	if ( ( drawn_id == 0 and neighbor_id == 3 )
		 or
		 ( drawn_id == 3 and neighbor_id == 0 )):
		return true
