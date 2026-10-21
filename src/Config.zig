//! This module represents driver's configuration.
const std = @import("std");
const drivercom = @import("drivercom.zig");
const Config = @This();
pub const Info = @import("Config/Info.zig");

/// Driver ID
id: u16,
/// CC-Link Station ID
station: u16,
/// CC-Link baud rate
cc_link_speed: drivercom.CcLinkSpeed,
flags: Flags,
line: struct {
    /// Total number of axes in line.
    axes: u32,
    /// Axis length used in the whole line.
    axis_length: f32,
    /// Slider configuration in the whole line.
    slider: struct {
        mass: f32,
        length: f32,
    },
    /// Magnet pitch (m)
    magnet_pitch: f32,
},
voltage_warmup: f32,
retry_count: u8,
hall_cutoff_freq: f32,
overcurrent_timeout: f32,
pos_offset: f32,
right_sensor_distance: f32,
angle_offset: f32, // Can be changed from `set_calibration_info` command
section_count: SectionCount,
axes: [3]Axis,
state: State, // Immutable fields, written from driver

/// Immutable states of driver
pub const State = struct {
    servo_enabled: bool,
    cc_link_enabled: bool,
    calibrated: bool,
    vdc: f32,
    thermo: f32,
    sys_version: f32,
    sensor: struct {
        home: u8,
        id0: u8,
        id1: u8,
        id2: u8,
    },
    synchronization_request_position: struct {
        forward: f32,
        backward: f32,
    },
    section_count: struct {
        /// Count at which the secondary axis is switched off, depends on the
        /// slider movement direction.
        deactivate_secondary: struct {
            left: struct {
                forward: struct { axis2: i16, axis3: i16 },
                backward: struct { axis1: i16, axis2: i16 },
            },
            right: struct {
                forward: struct { axis2: i16, axis3: i16 },
                backward: struct { axis1: i16, axis2: i16 },
            },
        },
        /// Count at which the axis is activated as the primary, depends on
        /// the slider movement direction.
        activate_primary: struct {
            left: struct {
                forward: struct { axis1: i16, axis2: i16, axis3: i16 },
                backward: struct { axis1: i16, axis2: i16, axis3: i16 },
            },
            right: struct {
                forward: struct { axis1: i16, axis2: i16, axis3: i16 },
                backward: struct { axis1: i16, axis2: i16, axis3: i16 },
            },
        },
    },
    axes: [3]State.Axis,

    pub const Axis = struct {
        enabled: bool,
        primary: bool,
        slider: struct { id: u8, state: drivercom.Fsm },
        entrance: drivercom.Entrance,
        overcharge_state: drivercom.Fsm,
        pitch_count: i16,
        mechanical_position: f32,
        // a and b needs confirmation.
        bias: struct { a: f32, b: f32 },
    };
};

pub const SectionCount = struct {
    /// Count at which the next axis in the travel direction becomes the
    /// primary and the current axis becomes the secondary.
    skip: i16,
    max: struct { axis1: i16, axis2: i16, axis3: i16 },
};

pub const Axis = struct {
    rs: f32,
    ls: f32,
    kf: f32,
    kbm: f32,
    max_current: f32,
    continuous_current: f32,
    gain: struct {
        current: CurrentGain,
        speed: SpeedGain,
        position: PositionGain,
    },
    arrival_threshold: f32,
    base_position: f32,
    sensor: struct {
        position: struct {
            on: struct {
                /// Position of right sensor when slider moves forward and
                /// turned on the sensor
                forward: f32,
                /// Position of left sensor when slider moves backward and
                /// turned on the sensor
                backward: f32,
            },
            off: struct {
                /// Position of left sensor when slider moves forward and
                /// turned off the sensor
                forward: f32,
                /// Position of right sensor when slider moves backward and
                /// turned off the sensor
                backward: f32,
            },
        },
        section_count: struct {
            on: struct {
                /// Section count of right sensor when slider moves forward and
                /// turned on the sensor
                forward: i16,
                /// Section count of left sensor when slider moves backward and
                /// turned on the sensor
                backward: i16,
            },
            off: struct {
                /// Section count of left sensor when slider moves forward and
                /// turned off the sensor
                forward: i16,
                /// Section count of right sensor when slider moves backward and
                /// turned off the sensor
                backward: i16,
            },
        },
    },
};

pub const Flags = struct {
    home_exists: bool,
    has_neighbor: packed struct(u2) {
        backward: bool,
        forward: bool,
    },
    use_axis: packed struct(u2) {
        axis2: bool,
        axis3: bool,
    },
    calibration_spare: packed struct(u2) {
        backward: bool,
        forward: bool,
    },
    collision_avoidance: bool,
    calibration_use: bool,
    xts: bool,
    /// Flip all sensors in a driver
    flip: bool,
    /// Swap all sensors in a driver
    swap: bool,
};

pub const CurrentGain = struct {
    p: f32,
    i: f32,
    denominator: u16,
};

pub const SpeedGain = struct {
    p: f32,
    i: f32,
    denominator: u16,
    denominator_pi: u16,
};

pub const PositionGain = struct {
    p: f32,
    denominator: u16,
};

test {
    std.testing.refAllDecls(@This());
}
