//! Type, description and unit of every `Log` field, in the same layout as
//! `Log`. `x: Type` names the type of field `x`, and `__x: Meta` describes
//! it. The unit of a `config` item is the unit of the value it logs.
//!
//! Descriptions and units come from the SHDrv tool. A unit is left out where
//! SHDrv does not state one.

pub const Type = []const u8;
pub const Meta = struct {
    description: ?[]const u8 = null,
    unit_short: ?[]const u8 = null,
    unit_long: ?[]const u8 = null,
};

duration: Type = "f32",
__duration: Meta = .{
    .description = "Logging duration.",
    .unit_short = "s",
    .unit_long = "Second",
},
config: struct {
    profile_position: Type = "bool",
    __profile_position: Meta = .{
        .description = "Output position of profile.",
    },
    profile_speed: Type = "bool",
    __profile_speed: Meta = .{
        .description = "Applied speed of profile.",
    },
    position_output: Type = "bool",
    __position_output: Meta = .{
        .description = "Output of position controller.",
    },
    position_reference: Type = "bool",
    __position_reference: Meta = .{
        .description = "Reference of position controller.",
    },
    position_feedback: Type = "bool",
    __position_feedback: Meta = .{
        .description = "Feedback of position controller.",
    },
    speed_reference: Type = "bool",
    __speed_reference: Meta = .{
        .description = "Reference of speed controller.",
    },
    speed_feedback: Type = "bool",
    __speed_feedback: Meta = .{
        .description = "Feedback of speed controller.",
    },
    current_q_reference: Type = "bool",
    __current_q_reference: Meta = .{
        .description = "Q-axis current reference of current controller.",
    },
    current_q_feedback: Type = "bool",
    __current_q_feedback: Meta = .{
        .description = "Q-axis current feedback of current controller.",
    },
    current_d_feedback: Type = "bool",
    __current_d_feedback: Meta = .{
        .description = "D-axis current feedback of current controller.",
    },
    voltage_q_reference: Type = "bool",
    __voltage_q_reference: Meta = .{
        .description = "Q-axis voltage reference.",
    },
    voltage_d_reference: Type = "bool",
    __voltage_d_reference: Meta = .{
        .description = "D-axis voltage reference.",
    },
    voltage_q_feedforward: Type = "bool",
    __voltage_q_feedforward: Meta = .{
        .description = "Q-axis voltage feedforward.",
    },
    voltage_d_feedforward: Type = "bool",
    __voltage_d_feedforward: Meta = .{
        .description = "D-axis voltage feedforward.",
    },
    calculation_time: Type = "bool",
    __calculation_time: Meta = .{
        .description = "Calculation time of control loop.",
    },
    theta_section: Type = "bool",
    __theta_section: Meta = .{ .description = "Theta section." },
    electrical_angular_speed: Type = "bool",
    __electrical_angular_speed: Meta = .{
        .description = "Electrical angular speed.",
    },
    in_position: Type = "bool",
    __in_position: Meta = .{
        .description = "In-position state of profile movement.",
    },
    current_a: Type = "bool",
    __current_a: Meta = .{
        .description = "A-phase current.",
    },
    current_b: Type = "bool",
    __current_b: Meta = .{
        .description = "B-phase current.",
    },
    current_c: Type = "bool",
    __current_c: Meta = .{
        .description = "C-phase current.",
    },
    voltage_alpha: Type = "bool",
    __voltage_alpha: Meta = .{
        .description = "Alpha-axis voltage.",
    },
    voltage_beta: Type = "bool",
    __voltage_beta: Meta = .{
        .description = "Beta-axis voltage.",
    },
    slider_state: Type = "bool",
    __slider_state: Meta = .{ .description = "State of Slider's FSM." },
    applied_angle: Type = "bool",
    __applied_angle: Meta = .{
        .description = "Applied angle.",
    },
    encoder_angle: Type = "bool",
    __encoder_angle: Meta = .{
        .description = "Angle measured by encoder.",
    },
    voltage_a: Type = "bool",
    __voltage_a: Meta = .{ .description = "A-phase voltage." },
    voltage_b: Type = "bool",
    __voltage_b: Meta = .{ .description = "B-phase voltage." },
    voltage_c: Type = "bool",
    __voltage_c: Meta = .{ .description = "C-phase voltage." },
    vector_sector: Type = "bool",
    __vector_sector: Meta = .{ .description = "Vector sector number." },
    hall_alarm_left: Type = "bool",
    __hall_alarm_left: Meta = .{ .description = "Left hall sensor alarm." },
    hall_alarm_right: Type = "bool",
    __hall_alarm_right: Meta = .{ .description = "Right hall sensor alarm." },
} = .{},
__config: Meta = .{
    .description =
    \\Items logged on every selected Axis.
    ,
},
axes: struct {
    axis1: Type = "bool",
    axis2: Type = "bool",
    axis3: Type = "bool",
} = .{},
__axes: Meta = .{ .description = "Axes to be logged." },
command: Command = .{},
__command: Meta = .{
    .description =
    \\Command run by Driver while logging.
    ,
},

pub const Command = struct {
    current_state: struct {} = .{},
    __current_state: Meta = .{
        .description = "Log Driver at current state.",
    },
    position_profile: Profile = .{},
    __position_profile: Meta = .{
        .description = "Log Driver while moving Slider with position profile.",
    },
    speed_profile: Profile = .{},
    __speed_profile: Meta = .{
        .description = "Log Driver while moving Slider with speed profile.",
    },

    pub const Profile = struct {
        slider_id: Type = "u8",
        __slider_id: Meta = .{
            .description = "ID of Slider targeted by command.",
        },
        distance: Type = "f32",
        __distance: Meta = .{
            .description =
            \\Travel distance. Negative distance travels backward.
            ,
            .unit_short = "m",
            .unit_long = "Meter",
        },
        speed: Type = "f32",
        __speed: Meta = .{
            .description = "Percentage of maximum speed.",
            .unit_short = "%",
            .unit_long = "Percent",
        },
        acceleration: Type = "f32",
        __acceleration: Meta = .{
            .description = "Percentage of maximum acceleration.",
            .unit_short = "%",
            .unit_long = "Percent",
        },
    };
};
