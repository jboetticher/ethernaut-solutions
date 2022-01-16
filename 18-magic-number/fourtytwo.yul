/* Disclaimer: this doesn't exactly work right.

This was a hard one. I had to learn how to use yul because I didn't want to write in 
Op codes. I'm fairly certain that yul worked out alright, but... there's a catch.

https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2
Looking at this "how-to" guide for writing the op codes, the answer should be:

600a600c600039600a6000f3 604260805260206080f3

When I compile my code, I get:
600a600d600039600a6000f3 fe604260005260206000f3

Besides 80 being replaced by 00 a few times, the major difference is the "fe" 
op code. I looked it up: https://github.com/wolflo/evm-opcodes. "FE" should be an
invalid opcode. I have no clue what is going on here.
The 80 being replaced by 00 is important, however. I believe that it has to do 
with where the data is being stored, which is why the compiled version didn't work 
right either.

With some more searching, I was suprised to find someone who wrote the exact same code
as I did in yul. That made me feel good, because it meant that I was on the right track,
but I can't get the compiler to get what the medium article did.
https://github.com/Jeiwan/ethernaut-solutions/blob/main/contracts/MagicNumber.yul

But hey, I mostly got to the right answer, so I'm willing to stick with that. Learning
a bit of yul will be interesting for in-line assembly anyways.

By the way, the real bytecode that you need is: 
0x600a600c600039600a6000f3602A60805260206080f3

The medium article usees 0x42 instead of 0x2A.

*/

object "FourtyTwoContract" {
    code {
        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            mstore(0, 0x2A)
            return(0, 0x20)  
        }
    }
}