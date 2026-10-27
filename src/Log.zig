//! This module represents driver's logging configuration. The driver runs the
//! command while recording the configured items of the selected axes at 15000
//! samples per second.
const std = @import("std");
const drivercom = @import("drivercom.zig");

/// Number of cycles per 1 second in the firmware.
pub const FREQUENCY: u32 = 15000;

/// Logging duration (>0 s).
duration: f32,
/// Items to be logged on every selected axis.
config: Config,
/// Axes to be logged.
axes: Axes,
/// Command run by the driver while logging.
command: Command,

pub const Axes = struct {
    axis1: bool,
    axis2: bool,
    axis3: bool,
};

pub const Command = union(Kind) {
    // TODO: Support the remaining commands SHDrv provide:
    // - Offline commands with applied voltage (V) and applied angle (turn):
    //   warm_up = 1, move_home = 2, move_forward = 3,
    //   move_backward = 4, restart = 5, move_synchronous = 6, move_dq = 7
    // - current_step = 10 with Q current step (A)
    // - speed_step = 11 with speed step (m/s)
    // - position_step = 12 with position step
    /// Offline command that logs the driver as it stands.
    current_state: struct {},
    position_profile: Profile,
    speed_profile: Profile,

    pub const Kind = enum(u8) {
        current_state = 0,
        position_profile = 13,
        speed_profile = 14,
    };

    pub const Profile = struct {
        /// ID of the slider targeted by the command (>0).
        slider_id: u8,
        // Unit is unconfirmed: SHDrv labels it m but limits it as rad.
        /// Travel distance. Negative distance travels backward.
        distance: f32,
        /// Percentage of the maximum speed (%).
        speed: f32,
        /// Percentage of the maximum acceleration (%).
        acceleration: f32,
    };
};

/// Field order is the item index. The response tags the item with its index
/// plus one.
pub const Config = packed struct(u32) {
    /// Output position of the profile.
    profile_position: bool,
    /// Applied speed of the profile.
    profile_speed: bool,
    /// Output of the position controller.
    position_output: bool,
    /// Reference of the position controller (rad).
    position_reference: bool,
    /// Feedback of the position controller (rad).
    position_feedback: bool,
    /// Reference of the speed controller (rad/s).
    speed_reference: bool,
    /// Feedback of the speed controller (rad/s).
    speed_feedback: bool,
    current_q_reference: bool,
    current_q_feedback: bool,
    current_d_feedback: bool,
    voltage_q_reference: bool,
    voltage_d_reference: bool,
    voltage_q_feedforward: bool,
    voltage_d_feedforward: bool,
    /// Calculation time of the control loop.
    calculation_time: bool,
    theta_section: bool,
    electrical_angular_speed: bool,
    in_position: bool,
    current_a: bool,
    current_b: bool,
    current_c: bool,
    voltage_alpha: bool,
    voltage_beta: bool,
    /// State of the slider's FSM.
    slider_state: bool,
    applied_angle: bool,
    encoder_angle: bool,
    voltage_a: bool,
    voltage_b: bool,
    voltage_c: bool,
    vector_sector: bool,
    hall_alarm_left: bool,
    hall_alarm_right: bool,
};

/// Logged item, valued by its index in `Config`.
pub const Item = Item: {
    const names = @typeInfo(Config).@"struct".field_names;
    var values: [names.len]u5 = undefined;
    for (&values, 0..) |*value, index| {
        value.* = index;
    }
    break :Item @Enum(u5, .exhaustive, names, &values);
};

/// Value type of a logged item.
pub fn ConfigType(comptime item: Item) type {
    return switch (item) {
        .profile_position,
        .profile_speed,
        .position_output,
        .position_reference,
        .position_feedback,
        .speed_reference,
        .speed_feedback,
        .current_q_reference,
        .current_q_feedback,
        .current_d_feedback,
        .voltage_q_reference,
        .voltage_d_reference,
        .voltage_q_feedforward,
        .voltage_d_feedforward,
        .calculation_time,
        .electrical_angular_speed,
        .current_a,
        .current_b,
        .current_c,
        .voltage_alpha,
        .voltage_beta,
        .applied_angle,
        .encoder_angle,
        .voltage_a,
        .voltage_b,
        .voltage_c,
        => f32,
        .theta_section,
        .vector_sector,
        => i32,
        .slider_state => drivercom.Fsm,
        .in_position,
        .hall_alarm_left,
        .hall_alarm_right,
        => bool,
    };
}

test {
    std.testing.refAllDecls(@This());
}
