from starkware.starknet.compiler.compile import \
    get_selector_from_name

print("L1 Address as Felt", int("0xa37be098189dc34129dbbd06943a399a359850c4", 16)) # 777760347573838001703990864850051202722831038661

print("L2 Address as Felt", int("0x0639aa0db29a45a6753e026ee330fa5712f716bdb25d3420f6359bc9a4982233", 16)) #
print("L2 Selector", get_selector_from_name('post_uni_v3_oracle_update'))