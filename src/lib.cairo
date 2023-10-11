
use starknet::ContractAddress;

#[starknet::interface]
trait OwnableData<T> {
   fn get_owner( self: @T) -> ContractAddress;
   fn is_owner( self: @T, addr: ContractAddress) -> bool ;
   fn transfer_ownership( ref self: T, new_owner: ContractAddress);
}
#[starknet::contract]
mod Owanable {
    use starknet::ContractAddress;

    use super::OwnableData;
    #[storage]
    struct Storage {
        owner:ContractAddress,
    }
    #[constructor]
    fn constructor(ref self: ContractState, init_owner: ContractAddress) {
        self.owner.write(init_owner);
    }

    #[external(v0)]
     impl OwnableDataImpl of OwnableData<ContractState> {
            fn get_owner( self: @ContractState) -> ContractAddress {
                self.owner.read()
            }
            fn transfer_ownership( ref self:ContractState, new_owner: ContractAddress) {
                self.owner.write(new_owner);
                self.emit(OwnershipTransferred {
                    previous_owner: self.owner.read(),
                    new_owner: new_owner,
                });
            }
             fn is_owner( self: @ContractState, addr: ContractAddress) -> bool {
                self.owner.read() == addr
             }
        }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnershipTransferred: OwnershipTransferred,
    }
    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        previous_owner: ContractAddress,
        new_owner: ContractAddress,
    }

}
