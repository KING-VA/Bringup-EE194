import math
from typing import Optional, List
from decimal import *

def real_to_scaled_ceil(x:Decimal, scale:Decimal) -> int:
    return math.ceil(x / scale)

def real_to_scaled_floor(x:Decimal, scale:Decimal) -> int:
    return math.floor(x / scale)

def scaled_to_real(x:int, scale:Decimal) -> Decimal:
    return x * scale

class PointReal:
    __slots__ = ["x", "y"]
    def __init__(self, x:Decimal, y:Decimal) -> None:
        self.x = x
        self.y = y

class Point:
    __slots__ = ["x", "y"]
    def __init__(self, x:int, y:int) -> None:
        self.x = x
        self.y = y

class Size:
    __slots__ = ["width", "height"]
    def __init__(self, width:int, height:int) -> None:
        self.width = width
        self.height = height

class BoundingBox:
    __slots__ = [
        "p0", 
        "p1"
    ]

    def __init__(self, p0:Point, p1:Point) -> None:
        self.p0 = p0
        self.p1 = p1

    def fromString(bbox:str) -> 'BoundingBox':
        x0, y0, x1, y1 = [Decimal(s) for s in bbox.split(" ")]
        return BoundingBox(
            Point(real_to_scaled_ceil(x0, snap.x), real_to_scaled_ceil(y0, snap.y)), 
            Point(real_to_scaled_ceil(x1, snap.x), real_to_scaled_ceil(y1, snap.y))
        )
    
    def fromOrigin(origin:Point, size:Size):
        return BoundingBox(origin, Point(origin.x + size.width, origin.y + size.height))
    
    def origin(self)->Point:
        return self.p0
    
    def max(self)->Point:
        return self.p1
    
    def size(self)->Size:
        return Size(self.p1.x - self.p0.x, self.p1.y - self.p0.y)

class Macro:
    __slots__ = [
        "name",
        "size",
        "placement",
        "mirror",
        "butterfly",
        "abut"
    ]

    def __init__(self, name:str, size_bbox:str, mirror=False, butterfly=False, abut=False) -> None:
        self.name = name
        sbbox = BoundingBox.fromString(size_bbox)
        self.size:Size = sbbox.size()
        self.placement:BoundingBox = None
        self.mirror = mirror
        self.butterfly = butterfly
        self.abut = abut

    def __str__(self) -> str:
        return "      {" + str.format("path: {}, type: hardmacro, x: {}, y: {}, orientation: {}, top_layer: m4".format(
            self.name, 
            scaled_to_real(self.placement.p0.x, snap.x), 
            scaled_to_real(self.placement.p0.y, snap.y),
            "my" if self.mirror else "r0")) + "}"

snap = PointReal(Decimal("0.108"), Decimal("0.09"))

tile_bounds = BoundingBox(Point(0, 0), Point(real_to_scaled_floor(Decimal(850.068), snap.x), real_to_scaled_floor(Decimal(453.6), snap.y)))

placed_macros:List[Macro] = []

edge_pad = 37
butterfly_abutt_pad = PointReal(Decimal(5), Decimal(6))

def place_xx(macro:Macro, left:Macro, align_bottom:Optional[Macro], top_edge:bool, padding:Decimal = Decimal(edge_pad), butterfly_padding_bonus = Decimal(edge_pad//2)):
    l_m = left.placement.max()
    align_placement = align_bottom.placement if align_bottom else left.placement
    if top_edge:
        align_origin = align_placement.max().y - macro.size.height
    else:
        # bonus = Decimal(0)
        # if macro.butterfly and macro.mirror:
        #     # We are the right wing of the butterfly. abutt.
        #     align_origin = align_placement.origin().y + butterfly_abutt_pad
        # else:
        #     if left.butterfly and left.mirror:
        #         # if our left is the the right wing of a butterfly, keep away a bit
        #         bonus = butterfly_padding_bonus
        align_origin = align_placement.origin().y

    abutted_padding = butterfly_abutt_pad.x if macro.abut else padding
    left_pad = Decimal(0)
    if left.butterfly:
        if left.mirror:
            # The element to our left is the right element of a butter fly. Give it the bonus back off
            left_pad = abutted_padding + butterfly_padding_bonus
        else:
            # We're the other element of the butterfly! Abut.
            assert(macro.butterfly and macro.mirror)
            left_pad = butterfly_abutt_pad.x
    else:
        left_pad = abutted_padding

    if macro.butterfly and not macro.mirror:
    # If we're the left element of a butterfly, we always get an extra bonus
    # If our neighbor is also a butterfly, we should and do get two bonuses
        left_pad += butterfly_padding_bonus


    macro.placement = BoundingBox.fromOrigin(
        origin=Point(l_m.x + left_pad, align_origin),
        size=macro.size
    )

def place_yy(macro:Macro, bottom:Macro, align_left:Optional[Macro], right_edge:bool, padding:Decimal = Decimal(edge_pad)):
    l_m = bottom.placement.max()
    align_placement = align_left.placement if align_left else bottom.placement
    if right_edge:
        align_origin = align_placement.max().x - macro.size.width
    else:
        align_origin = align_placement.origin().x
    
    abutted_padding = butterfly_abutt_pad.y if macro.abut else padding
    macro.placement = BoundingBox.fromOrigin(
        origin=Point(align_origin, l_m.y + abutted_padding),
        size=macro.size
    )

def place(placer, origin, invert_snap, arrays):
    first_macro = arrays[0]
    first_macro.placement = BoundingBox.fromOrigin(origin, first_macro.size)
    placements = [
        first_macro
    ]
    for i in range(1, len(arrays)):
        macro = arrays[i]
        placer(macro, placements[i - 1], None, invert_snap)
        placements.append(macro)
    return placements

def place_aligned(placer, prev, align, invert_snap, arrays):
    placements = []
    for i in range(len(arrays)):
        macro = arrays[i]
        placer(macro, prev if i == 0 else placements[i - 1], align, invert_snap)
        placements.append(macro)
    return placements

final = []

icache_r0 = place(placer=place_xx, origin=Point(0, 0), invert_snap=False, arrays=[
    Macro("BoomTile/frontend/icache/tag_array/tag_array_2_ext/mem_0_0", "654.786 246.3295 706.238 334.7095"),
    Macro("BoomTile/frontend/icache/tag_array/tag_array_2_ext/mem_0_1", "712.248 245.0665 763.7 333.4465"),
    Macro("BoomTile/frontend/icache/dataArrayWay_0/dataArrayWay_0_ext/mem_0_0", "112.104 0.9 163.556 118.44"),
    Macro("BoomTile/frontend/icache/dataArrayWay_1/dataArrayWay_0_ext/mem_0_0", "112.104 0.9 163.556 118.44"),
    Macro("BoomTile/frontend/icache/dataArrayWay_2/dataArrayWay_0_ext/mem_0_0", "112.104 0.9 163.556 118.44"),
    Macro("BoomTile/frontend/icache/dataArrayWay_3/dataArrayWay_0_ext/mem_0_0", "112.104 0.9 163.556 118.44"),
    # ("BoomTile/core/rob/rob_debug_inst_mem/rob_debug_inst_mem_ext/mem_0_0", "0.0 0.0 20.24 113.58"),
    Macro("BoomTile/tcache/tcache_meta/tcache_meta_ext/mem_0_0", "588.5965 171.9895 606.2445 285.5695", mirror=False, butterfly=True),
    Macro("BoomTile/tcache/tcache_meta/tcache_meta_ext/mem_0_1", "588.5965 171.9895 606.2445 285.5695", mirror=True, butterfly=True),
    Macro("BoomTile/tcache/tcache_meta/tcache_meta_ext/mem_0_2", "588.5965 171.9895 606.2445 285.5695", mirror=False, butterfly=True),
    Macro("BoomTile/tcache/tcache_data/tcache_data_ext/mem_0_0", "572.9335 44.27 593.1735 157.85", mirror=True, butterfly=True),
])
final += icache_r0

# dcache_r0_bb_str = "541.845 248.22 690.281 309.96"
# dcache_r0_bb = BoundingBox.fromString(dcache_r0_bb_str)
# dcache_r0 = place(placer=place_yy, origin=Point(tile_bounds.size().width - edge_pad - dcache_r0_bb.size().width, edge_pad), invert_snap=True, arrays=[
#     ("BoomTile/dcache/data/array_0_0_0/array_0_0_0_ext/mem_0_0", dcache_r0_bb_str),
#     ("BoomTile/dcache/data/array_1_0_0/array_0_0_0_ext/mem_0_0", "542.429 186.4845 690.865 248.2245"),
#     ("BoomTile/dcache/meta_0/tag_array/tag_array_1_ext/mem_0_0", "603.6865 116.55 636.9945 207.45")
# ])
# final += dcache_r0

# dcache_r1 = place(placer=place_yy, origin=Point(tile_bounds.size().width - edge_pad - dcache_r0_bb.size().width - edge_pad - dcache_r0_bb.size().width, edge_pad), invert_snap=True, arrays=[
#     ("BoomTile/dcache/data/array_2_0_0/array_0_0_0_ext/mem_0_0", "439.377 141.119 587.813 202.859"),
#     ("BoomTile/dcache/data/array_3_0_0/array_0_0_0_ext/mem_0_0", "512.562 88.1995 660.998 149.9395"),
# ])
# final += dcache_r1
dcache_r0_bb_str = "541.845 248.22 690.281 309.96"
dcache_r0_bb = BoundingBox.fromString(dcache_r0_bb_str)
dcache_r0 = place(placer=place_yy, origin=Point(tile_bounds.size().width - dcache_r0_bb.size().width, 0), invert_snap=True, arrays=[
    Macro("BoomTile/dcache/data/array_0_0_0/array_0_0_0_ext/mem_0_0", dcache_r0_bb_str, abut=True),
    Macro("BoomTile/dcache/data/array_1_0_0/array_0_0_0_ext/mem_0_0", dcache_r0_bb_str, abut=True),
    Macro("BoomTile/dcache/data/array_2_0_0/array_0_0_0_ext/mem_0_0", dcache_r0_bb_str, abut=True),
    Macro("BoomTile/dcache/data/array_3_0_0/array_0_0_0_ext/mem_0_0", dcache_r0_bb_str, abut=True),
    Macro("BoomTile/dcache/meta_0/tag_array/tag_array_1_ext/mem_0_0", "603.6865 116.55 636.9945 207.45", abut=True)
])
final += dcache_r0


bpd_c0 = place_aligned(placer=place_yy, prev=icache_r0[0], align=None, invert_snap=False, arrays=[
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_2/meta_0/meta_0_ext/mem_0_0", "57.24 188.9935 106.812 299.3335", mirror=True),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_2/btb_0/btb_0_ext/mem_0_0", "78.6305 151.2005 126.6265 206.4605", mirror=True),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_2/ebtb/ebtb_ext/mem_0_0", "163.962 222.3895 211.958 264.6895", mirror=True),
    Macro("BoomTile/frontend/ftq/meta_0/meta_0_0_ext/mem_0_0", "53.136 364.05 76.076 432.27", mirror=True),
])
final += bpd_c0

bpd_c1 = place_aligned(placer=place_xx, prev=bpd_c0[0], align=None, invert_snap=False, arrays=[
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_2/meta_1/meta_0_ext/mem_0_0", "116.532 185.2195 164.914 295.5595", mirror=True)
])
bpd_c1 += place_aligned(placer=place_yy, prev=bpd_c1[0], align=None, invert_snap=False, arrays=[
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_2/btb_1/btb_0_ext/mem_0_0", "141.861 152.47 189.857 207.73", mirror=True),
])
final += bpd_c1

bp0_c0_top_bb_str = "3.996 433.53 83.852 446.67"
bp0_c0_top_bb = BoundingBox.fromString(bp0_c0_top_bb_str)
bpd_r0 = place(placer=place_xx, origin=Point(0, tile_bounds.size().height - bp0_c0_top_bb.size().height), invert_snap=True, arrays=[
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/lo_us/hi_us_ext/mem_0_0", bp0_c0_top_bb_str, mirror=True),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/hi_us/hi_us_ext/mem_0_0", "401.868 480.42 481.724 493.56", mirror=True),
    Macro("BoomTile/frontend/ftq/ghist_0/ghist_0_ext/mem_0_0", "168.912 432.72 195.308 449.1", mirror=False, butterfly=True),
    Macro("BoomTile/frontend/ftq/ghist_0/ghist_0_ext/mem_0_1", "195.912 432.72 222.308 449.1", mirror=True, butterfly=True),
    Macro("BoomTile/frontend/ftq/ghist_0/ghist_0_ext/mem_0_2", "222.912 432.72 249.308 449.1"),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_1/data/data_ext/mem_0_0", "1.08 351.81 148.004 387.63", abut=True),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/table_0/table_ext/mem_0_0", "91.7195 421.479 139.7155 467.019", False, True),
    Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/table_0/table_ext/mem_1_0", "94.7175 373.58 142.7135 419.12", True, True),
])
final += bpd_r0

# bpd_r0_1_bb_str = "1.08 351.81 148.004 387.63"
# bpd_r0_1_bb = BoundingBox.fromString(bpd_r0_1_bb_str)
# bpd_r0_1 = place(placer=place_xx, origin=Point(bpd_r0[-1].placement.max().x + butterfly_abutt_pad.x, tile_bounds.size().height - bpd_r0_1_bb.size().height - edge_pad), invert_snap=True, arrays=[
#     Macro("BoomTile/frontend/bpd/banked_predictors_0/components_1/data/data_ext/mem_0_0", bpd_r0_1_bb_str),
#     Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/table_0/table_ext/mem_0_0", "91.7195 421.479 139.7155 467.019", False, True),
#     Macro("BoomTile/frontend/bpd/banked_predictors_0/components_3/tables_0/table_0/table_ext/mem_1_0", "94.7175 373.58 142.7135 419.12", True, True),
# ])
# final += bpd_r0_1

#Pin to the first ghist in the upper row
bpd_r1_pin:BoundingBox = bpd_r0[2].placement
bpd_r1_first_bb_str = "168.912 413.01 195.308 429.39"
bpd_r1_first_bb = BoundingBox.fromString(bpd_r1_first_bb_str)
bpd_r1 = place(placer=place_xx, origin=Point(bpd_r1_pin.origin().x, bpd_r1_pin.origin().y - bpd_r1_first_bb.size().height), invert_snap=True, arrays=[
    Macro("BoomTile/frontend/ftq/ghist_1/ghist_0_ext/mem_0_0", bpd_r1_first_bb_str, mirror=False, butterfly=True),
    Macro("BoomTile/frontend/ftq/ghist_1/ghist_0_ext/mem_0_1", "195.912 413.01 222.308 429.39", mirror=True, butterfly=True),
    Macro("BoomTile/frontend/ftq/ghist_1/ghist_0_ext/mem_0_2", "222.912 413.01 249.308 429.39"),
])
final += bpd_r1

# bpd_r0 = place(placer=)


print(",\n".join([str(f) for f in final]))

area = sum([f.size.width * f.size.height for f in final])
print(f"area = {area}")
