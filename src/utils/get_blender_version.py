"""
Utility to check Blender version.

Returns the version tuple or None if Blender is not available.
"""

import re
import subprocess
from typing import Optional, Tuple


def get_blender_version(blender_exe: str) -> Optional[Tuple[int, int, int]]:
    """
    Get Blender version by running `blender --version`.

    Args:
        blender_exe: Path to Blender executable

    Returns:
        Tuple of (major, minor, patch) version numbers or None if version cannot be determined
    """
    try:
        result = subprocess.run(
            [blender_exe, "--version"],
            capture_output=True,
            text=True,
            check=True,
            timeout=30,
        )
        # Parse version from output (e.g., "Blender 4.2.0")
        match = re.search(r"Blender\s+(\d+)\.(\d+)\.(\d+)", result.stdout)
        if match:
            return (int(match.group(1)), int(match.group(2)), int(match.group(3)))
    except (subprocess.SubprocessError, ValueError, FileNotFoundError):
        pass
    return None


def is_blender_version_gte(version: Tuple[int, int, int], min_version: Tuple[int, int, int]) -> bool:
    """
    Check if a version is greater than or equal to a minimum version.

    Args:
        version: Tuple of (major, minor, patch) version numbers
        min_version: Tuple of (major, minor, patch) minimum version numbers

    Returns:
        True if version >= min_version, False otherwise
    """
    return version >= min_version
