local mg     = require "moongen"
local memory = require "memory"
local device = require "device"
local ts     = require "timestamping"
local stats  = require "stats"
local hist   = require "histogram"
local timer  = require "timer"

local ETH_SRC =  "0C:C4:7A:19:73:B6"
local ETH_DST =  "0c:c4:7a:19:74:30"
local eth_addresses_str = {"52:67:f7:65:74:e2", "b2:85:38:6e:df:bc", "ee:14:a4:5f:dc:f6", "ee:c4:fd:68:14:c4" , "b2:a6:35:6f:e6:c7", "4a:50:54:ed:de:76", "8e:69:26:d2:c3:30", "86:b3:7b:e0:31:65"}


local function getRstFile(...)
	local args = { ... }
	for i, v in ipairs(args) do
		result, count = string.gsub(v, "%-%-result%=", "")
		if (count == 1) then
			return i, result
		end
	end
	return nil, nil
end

function convertMacAddress(address)
	  local bytes = {string.match(address,
                    '(%x+)[-:](%x+)[-:](%x+)[-:](%x+)[-:](%x+)[-:](%x+)')}

    local convertedAddress = 0
    for i = 1, 6 do
        convertedAddress = convertedAddress + 
                           tonumber(bytes[#bytes + 1 - i], 16) * 256 ^ (i - 1)
    end
    return convertedAddress
end


function configure(parser)
	parser:description("Generates bidirectional CBR traffic with hardware rate control and measure latencies.")
	parser:argument("dev1", "Device to transmit/receive from."):convert(tonumber)
        parser:argument("dev2", "Device to transmit/receive from."):convert(tonumber)
	parser:option("-r --rate", "Transmit rate in Mbit/s."):default(10000):convert(tonumber)
        parser:option("-s --size", "Packet size in Bytes"):default(80):convert(tonumber)
        parser:option("-n --number", "Number of receiving interfaces"):default(8):convert(tonumber)
        parser:option("-c --flowCount", "Flow count"):default(0):convert(tonumber)
	parser:option("-f --file", "Filename of the latency histogram."):default("histogram.csv")
end

function master(args)
	local dev1 = device.config({port = args.dev1, rxQueues = 3, txQueues = 3})
	local dev2 = device.config({port = args.dev2, rxQueues = 3, txQueues = 3})
        local PKT_SIZE = args.size
        local number = args.number
        local flowCount = args.flowCount
        local ips = {}

        device.waitForLinks()
        dev1:getTxQueue(0):setRate(args.rate)
	mg.startTask("loadSlave", dev1:getTxQueue(0), PKT_SIZE, number, flowCount, ips)

	stats.startStatsTask{dev1}
	mg.waitForTasks()
end

function loadSlave(queue, PKT_SIZE, number, flowCount, ips)
            local converted1 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[1]) + 0ULL), 16)
            local converted2 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[2]) + 0ULL), 16) 
            local converted3 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[3]) + 0ULL), 16) 
            local converted4 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[4]) + 0ULL), 16) 
            local converted5 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[5]) + 0ULL), 16) 
            local converted6 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[6]) + 0ULL), 16) 
            local converted7 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[7]) + 0ULL), 16) 
            local converted8 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[8]) + 0ULL), 16) 
            local converted_src = bit.rshift(bit.bswap(convertMacAddress(ETH_SRC) + 0ULL), 16) 
            local converted_dst = bit.rshift(bit.bswap(convertMacAddress(ETH_DST) + 0ULL), 16)

            local eth_addresses_mac = {converted1, converted2, converted3, converted4, converted5, converted6, converted7, converted8}

            local mem = memory.createMemPool(function(buf)
                    buf:getTcpPacket():fill{
			ethSrc = txDev,
                        ethDst = eth_addresses_str[0],
                        ethType = 0x0800,
                        ip4Dst = math.random(1, 2^32 - 1), 
                        ip4Src = math.random(1, 2^32 - 1),
                        ip4Version = 4
		    }	    
            end)
	    local bufs = mem:bufArray()
            local counter = 0
		bufs:alloc(PKT_SIZE)
	            while mg.running() do
                    for _, buf in ipairs(bufs) do
                        local pkt = buf:getTcpPacket()
                        counter = (counter + 1) % flowCount
                        if (counter == 0) then 
                            counter = 1
                        end
                        pkt.ip4.src:set(math.random(0, 2^32 - 1))
                        pkt.ip4.dst:set(math.random(2^32 - 1 - flowCount, 2^32 - 1)) 
                        
                        pkt.eth:setDst(eth_addresses_mac[math.random(1, number)])
                        pkt.eth:setSrc(converted_src)                  
		    end
                    bufs:offloadTcpChecksums()
		    queue:send(bufs)
            end
end

function timerSlave(txQueue, rxQueue, histfile)
        local converted1 = bit.rshift(bit.bswap(convertMacAddress(eth_addresses_str[1]) + 0ULL), 16)
	local timestamper = ts:newUdpTimestamper(txQueue, rxQueue)
        local rateLimit = timer:new(0.001)
	local hist = hist:new()
	mg.sleepMillis(300) -- ensure that the load task is running
	while mg.running() do 
		hist:update(timestamper:measureLatency(84, function(buf)
							buf:getUdpPacket():fill{
				                        ethSrc = txDev,
                        				ethDst = eth_addresses_str[0],
                        				ethType = 0x0800,
                        				ip4Dst = math.random(0, 2^32 - 1), 
                        				ip4Src = math.random(0, 2^32 - 1),
                        				ip4Version = 4,
							udpDst = 319
                    					}	
			
                                                	local pkt = buf:getTcpPacket()
                                                	      pkt.ip4.src:set(math.random(0, 2^32 - 1))
                                                	      pkt.ip4.dst:set(math.random(0, 2^32 - 1))
                                            		      pkt.eth:setDst(converted1)

							end)) 
		rateLimit:wait()
		rateLimit:reset()
	end
	hist:print()
	hist:save(histfile)
end

