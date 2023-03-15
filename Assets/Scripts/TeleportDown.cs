using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TeleportDown : MonoBehaviour
{
    public float teleportHeight;
    public float speed;
    public float delayTime;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Down());
    }

    IEnumerator Down()
    {
        yield return new WaitForSeconds(delayTime);
        while (Vector3.Distance(new Vector3(this.transform.position.x, teleportHeight, this.transform.position.z), this.transform.position) > 0.1f)
        {
            float step = speed * Time.deltaTime;
            this.transform.position -= new Vector3(0f, speed * Time.deltaTime, 0f);
            // move sprite towards the target location
            yield return null;
        }
    }
}
