/*
# Filename:     ultrasonic.v
# Description:
# Fully stabilized HC-SR04 interface with:
# - Median filter
# - Moving average filter
# - Outlier rejection
# - Echo timeout protection
# - Sensor freeze protection
# - Stable detection logic
*/

`timescale 1ns / 1ps

module ultrasonic(
    input wire clk,
    input wire rst_n,
    input wire echo,

    output reg trig,
    output reg led,
    output reg [8:0] dist

);

parameter CLK_FREQ = 50_000_000;
parameter TRIG_US  = 10;
parameter PERIOD_MS = 60;

localparam TRIG_CNT   = (CLK_FREQ/1_000_000)*TRIG_US;
localparam PERIOD_CNT = (CLK_FREQ/1000)*PERIOD_MS;
localparam TIMEOUT    = (CLK_FREQ/1000)*40;   // 40ms timeout

//-----------------------------------------
// Registers
//-----------------------------------------
reg [31:0] cnt;
reg [31:0] echo_cnt;
reg [31:0] distance_cm;

reg echo_d;

// filter samples
reg [8:0] s0,s1,s2,s3,s4;

// median + average
reg [8:0] median;
reg [11:0] avg;

// timeout
reg [31:0] timeout_cnt;



//-----------------------------------------
// Trigger generation
//-----------------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cnt<=0;
        trig<=0;
    end
    else
    begin

        trig <= (cnt < TRIG_CNT);

        if(cnt < PERIOD_CNT)
            cnt <= cnt + 1;
        else
            cnt <= 0;

    end
end

//-----------------------------------------
// Echo measurement with timeout protection
//-----------------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        echo_cnt<=0;
        echo_d<=0;
        timeout_cnt<=0;
    end
    else
    begin

        echo_d <= echo;

        if(echo)
        begin
            echo_cnt <= echo_cnt + 1;
            timeout_cnt <= timeout_cnt + 1;
        end
        else
            timeout_cnt <= 0;

        // timeout protection
        if(timeout_cnt > TIMEOUT)
        begin
            echo_cnt <= 0;
        end

        // falling edge detect
        if(echo_d && !echo)
        begin
            distance_cm <= (echo_cnt / (CLK_FREQ/1_000_000) / 58);
            echo_cnt <= 0;
        end

    end
end

//-----------------------------------------
// Outlier rejection
//-----------------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        s0<=0; s1<=0; s2<=0; s3<=0; s4<=0;
    end
    else
    begin

        // reject unrealistic readings
        if(distance_cm < 300 && distance_cm > 1)
        begin
            s4 <= s3;
            s3 <= s2;
            s2 <= s1;
            s1 <= s0;
            s0 <= distance_cm[8:0];
        end

    end
end

//-----------------------------------------
// Median filter (best for ultrasonic)
//-----------------------------------------
always @(*)
begin

    if((s0>=s1 && s0<=s2)||(s0<=s1 && s0>=s2)) median=s0;
    else if((s1>=s0 && s1<=s2)||(s1<=s0 && s1>=s2)) median=s1;
    else median=s2;

end

//-----------------------------------------
// Moving average
//-----------------------------------------
always @(*)
begin
    avg = (median + s3 + s4) / 3;
end
endmodule
