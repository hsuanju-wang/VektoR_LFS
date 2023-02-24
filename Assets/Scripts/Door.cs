using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    /// <summary>
    /// Handle door close or open and which scene to enter.
    /// </summary>
    /// 

    private GameObject leftDoor;
    private GameObject rightDoor;
    public float speed;

    public float doorOpenWidth;
    public float timeDelayed;
    private SoundManager soundManager;

    void Start()
    {
        leftDoor = GameObject.Find("Cabin_Door_L");
        rightDoor = GameObject.Find("Cabin_Door_R");
        StartCoroutine(OpenDoor());
        soundManager = FindObjectOfType<SoundManager>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    IEnumerator OpenDoor()
    {
        yield return new WaitForSeconds(timeDelayed);
        soundManager.PlayDoorOpen();
        while (Vector3.Distance(leftDoor.transform.position, rightDoor.transform.position) < doorOpenWidth)
        {
            leftDoor.transform.position -= new Vector3(speed * Time.deltaTime, 0f, 0f);
            rightDoor.transform.position += new Vector3(speed * Time.deltaTime, 0f, 0f);
            // move sprite towards the target location
            yield return null;
        }
    }
}
