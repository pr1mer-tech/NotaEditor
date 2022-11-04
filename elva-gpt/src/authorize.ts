export function authorize(header: string): boolean {
    const [type, encoded] = header.split(' ');
    if (type !== 'Bearer') {
        return false;
    }
    const decoded = atob(encoded);
    // Decoded should be "Elva"
    return decoded === 'Elva';
}