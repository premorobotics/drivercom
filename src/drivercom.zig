const std = @import("std");
const build = @import("build.zig.zon");

pub const version =
    std.SemanticVersion.parse(build.version) catch unreachable;

pub const Config = @import("Config.zig");
pub const Message = @import("Message.zig");
pub const Log = @import("Log.zig");

pub const CcLinkSpeed = enum(u8) {
    @"156 kbps",
    @"625 kbps",
    @"2.5 Mbps",
    @"5 Mbps",
    @"10 Mbps",
    _,
};

pub const Fsm = enum(u8) {
    none = 0,
    warm_up = 1,
    warm_up_comp = 2,
    warm_up_fault = 3,
    curr_bias = 4,
    curr_bias_comp = 5,
    fwd_ramp = 8,
    fwd_ramp_comp = 9,
    fwd_ramp_fault = 10,
    bwd_ramp = 11,
    bwd_ramp_comp = 12,
    bwd_ramp_fault = 13,
    curr_step = 20,
    curr_step_comp = 21,
    curr_step_fault = 22,
    speed_step = 23,
    speed_step_comp = 24,
    speed_step_fault = 25,
    pos_step = 26,
    pos_step_comp = 27,
    pos_step_fault = 28,
    pos_prof = 29,
    pos_prof_comp = 30,
    pos_prof_fault = 31,
    fwd_calib = 32,
    fwd_calib_comp = 33,
    bwd_calib = 34,
    bwd_calib_comp = 35,
    speed_prof = 40,
    speed_prof_comp = 41,
    speed_prof_fault = 42,
    fwd_slave = 43,
    fwd_slave_comp = 44,
    bwd_slave = 45,
    bwd_slave_comp = 46,
    over_charge = 50,
    synch_com_error = 51,
    _,
};

pub const Entrance = enum(u8) {
    none = 0,
    left = 1,
    right = 2,
    _,
};

pub const gain = struct {
    pub const current = struct {
        pub fn wcc(denominator: u32) f64 {
            return 2.0 * std.math.pi * (15000.0 / @as(
                f64,
                @floatFromInt(denominator),
            ));
        }

        pub fn p(ls: f64, wcc_: f64) f64 {
            return ls * wcc_;
        }

        pub fn i(rs: f64, wcc_: f64) f64 {
            return rs * wcc_;
        }
    };

    pub const velocity = struct {
        pub fn wsc(denominator: u32, wcc: f64) f64 {
            return wcc / @as(f64, @floatFromInt(denominator));
        }

        pub fn wpi(denominator: u32, wsc_: f64) f64 {
            return wsc_ / @as(f64, @floatFromInt(denominator));
        }

        pub fn radius(pitch: f64) f64 {
            return pitch / (2.0 * std.math.pi);
        }

        pub fn inertia(mass: f64, radius_: f64) f64 {
            return mass * radius_ * radius_;
        }

        pub fn torqueConstant(force_constant: f64, radius_: f64) f64 {
            return force_constant * radius_;
        }

        pub fn p(inertia_: f64, torque_constant: f64, wsc_: f64) f64 {
            return (inertia_ * wsc_) / torque_constant;
        }

        pub fn i(p_: f64, wpi_: f64) f64 {
            return p_ * wpi_;
        }
    };

    pub const position = struct {
        pub fn wpc(denominator: u32, wsc: f64) f64 {
            return wsc / @as(f64, @floatFromInt(denominator));
        }

        pub fn p(wpc_: f64) f64 {
            return wpc_;
        }
    };
};

test {
    std.testing.refAllDecls(@This());
}
